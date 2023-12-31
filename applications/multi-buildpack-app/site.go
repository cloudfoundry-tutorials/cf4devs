package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {
	http.HandleFunc("/", hello)
	fmt.Println("listening...")
	err := http.ListenAndServe(":"+os.Getenv("PORT"), nil)
	if err != nil {
		panic(err)
	}
}

func hello(res http.ResponseWriter, req *http.Request) {
	rubyScriptLog, err := exec.Command("ruby", "./helloworld.rb").Output()
	if err != nil {
		log.Print("ERROR:", err)
		fmt.Fprintf(res, "ERROR: %v\n", err)
	} else {
		fmt.Fprintf(res, "The ruby script evaluated to: %s\n", rubyScriptLog)
	}
}
