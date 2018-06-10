package main

import (
	"io"
	"log"
	"net/http"
	"github.com/gorilla/websocket"
	"fmt"
)

var logFatal = log.Fatal
var logPrintf = log.Printf
var httpListenAndServe = http.ListenAndServe

type msg struct {
	Num int
}

func main() {
	RunServer()
}

func RunServer() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", HelloServer)
	mux.HandleFunc("/cable", wsHandler)
	logFatal("ListenAndServe: ", httpListenAndServe(":8090", mux))
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	logPrintf("%s request to %s\n", r.Method, r.RequestURI)
	io.WriteString(w, "hello, world!\n")
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
	var upgrader = &websocket.Upgrader{ReadBufferSize: 1024, WriteBufferSize: 1024}
	conn, err := upgrader.Upgrade(w, r, w.Header())
	if err != nil {
		http.Error(w, "Could not open websocket connection", http.StatusBadRequest)
	}

	go echo(conn)
}

func echo(conn *websocket.Conn) {
	defer conn.Close()
	for {
		m := msg{}

		err := conn.ReadJSON(&m)
		if err != nil {
			fmt.Println("Error reading json.", err)
			return
		}

		fmt.Printf("Got message: %#v\n", m)

		if err = conn.WriteJSON(m); err != nil {
			fmt.Println(err)
		}
	}
}