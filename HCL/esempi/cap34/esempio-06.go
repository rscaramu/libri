type Aula struct {
	Nome  string `hcl:"nome,label"`
	Posti int    `hcl:"posti"`
	Piano int    `hcl:"piano"`
	Note  string `hcl:"note,optional"`
}

type Orario struct {
	Scuola string `hcl:"scuola"`
	Aule   []Aula `hcl:"aula,block"`
}
