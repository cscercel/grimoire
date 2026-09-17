package main

import (
	"database/sql"
	"log"
	"os"

	"github.com/cscercel/grimoire/internal/config"
)

func main() {
	// Config
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("config error: %v:", err)
	}

	// Sync to Database
	db, err := sql.Open("libsql", cfg.DatabaseURL)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
}
