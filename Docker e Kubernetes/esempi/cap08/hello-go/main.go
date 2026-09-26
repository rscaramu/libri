package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func saluta(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Ciao da Go! Percorso: %s\n", r.URL.Path)
}

func main() {
	porta := os.Getenv("PORTA")
	if porta == "" {
		porta = "8080"
	}
	http.HandleFunc("/", saluta)
	log.Printf("In ascolto sulla porta %s", porta)
	log.Fatal(http.ListenAndServe(":"+porta, nil))
}
