package task

import (
	"context"
	"encoding/json"
	"errors"

	"cuelang.org/go/cue"
	"github.com/rs/zerolog/log"
	"go.dagger.io/dagger/compiler"
	"go.dagger.io/dagger/plancontext"
	"go.dagger.io/dagger/solver"
	"gopkg.in/yaml.v3"
)

func init() {
	Register("DecodeSecret", func() Task { return &decodeSecretTask{} })
}

type decodeSecretTask struct {
}

func (c *decodeSecretTask) Run(ctx context.Context, pctx *plancontext.Context, _ solver.Solver, v *compiler.Value) (*compiler.Value, error) {
	lg := log.Ctx(ctx)
	lg.Debug().Msg("decoding secret")

	input := v.Lookup("input")

	inputSecret, err := pctx.Secrets.FromValue(input)
	if err != nil {
		return nil, err
	}

	format, err := v.Lookup("format").String()
	if err != nil {
		return nil, err
	}

	lg.Debug().Str("format", format).Msg("unmarshaling secret")

	inputSecretPlaintext := inputSecret.PlainText()

	var unmarshaled map[string]interface{}

	switch format {
	case "json":
		err = json.Unmarshal([]byte(inputSecretPlaintext), &unmarshaled)
	case "yaml":
		err = yaml.Unmarshal([]byte(inputSecretPlaintext), &unmarshaled)
	}

	if err != nil {
		// returning err here could expose secret plaintext!
		return nil, errors.New("could not unmarshal secret")
	}

	output := compiler.NewValue()

	// recurse over unmarshaled to convert string values to secrets
	var convert func(p []cue.Selector, i interface{})
	convert = func(p []cue.Selector, i interface{}) {
		switch entry := i.(type) {
		case string:
			secret := pctx.Secrets.New(entry)
			path := cue.MakePath(append(p, cue.ParsePath("contents").Selectors()...)...)
			pathSelectors := path.Selectors()
			logPath := cue.MakePath(pathSelectors[1 : len(pathSelectors)-1]...)
			lg.Debug().Str("path", logPath.String()).Str("type", "string").Msg("found secret")
			output.FillPath(path, secret.MarshalCUE())
		case map[string]interface{}:
			for k, v := range entry {
				convert(append(p, cue.ParsePath(k).Selectors()...), v)
			}
		}
	}

	convert(cue.ParsePath("output").Selectors(), unmarshaled)

	return output, nil
}
