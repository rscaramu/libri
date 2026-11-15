func main() {
	parser := hclparse.NewParser()
	file, diags := parser.ParseHCLFile("orario.hcl")
	if diags.HasErrors() {
		log.Fatal(diags)
	}

	ctx := &hcl.EvalContext{
		Variables: map[string]cty.Value{
			"base": cty.NumberIntVal(18),
		},
		Functions: map[string]function.Function{
			"upper": stdlib.UpperFunc,
		},
	}

	var orario Orario
	diags = gohcl.DecodeBody(file.Body, ctx, &orario)
	if diags.HasErrors() {
		wr := hcl.NewDiagnosticTextWriter(
			os.Stderr, parser.Files(), 78, false)
		wr.WriteDiagnostics(diags)
		os.Exit(1)
	}

	fmt.Println("Scuola:", orario.Scuola)
	for _, a := range orario.Aule {
		fmt.Printf("%-4s posti=%d piano=%d %s\n",
			a.Nome, a.Posti, a.Piano, a.Note)
	}
}
