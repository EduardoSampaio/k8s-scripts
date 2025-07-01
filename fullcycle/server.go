package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

var startedAt = time.Now()

func main() {
	http.HandleFunc("/health", Healthz)
	http.HandleFunc("/configmap", ConfigMap)
	http.HandleFunc("/", Hello)

	http.ListenAndServe(":80", nil)
	fmt.Println("Server running on port 80")

}

func Hello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, %s!", os.Getenv("NAME"))
}

func ConfigMap(w http.ResponseWriter, r *http.Request) {
	data, err := os.ReadFile("/app/myfamily/family.txt")
	if err != nil {
		log.Fatalf("Error reading file: %v", err)
	}
	fmt.Fprintf(w, "My Family: %s", string(data))
}

func Healthz(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "OK - %v", time.Since(startedAt))
}
