package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World"))
		name := os.Getenv("NAME")
		fmt.Fprintf(w, "Hello World %s", name)
	})

	http.ListenAndServe(":80", nil)
	fmt.Println("Server running on port 80")

}
