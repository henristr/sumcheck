package main

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"hash"
	"io"
	"os"
)

func calcHash(algo string, expectedHash string, file string) {
	var h hash.Hash
	switch algo {
	case "sha256":
		h = sha256.New()
	case "sha512":
		h = sha512.New()
	case "sha1":
		h = sha1.New()
	case "md5":
		h = md5.New()
	default:
		fmt.Println("Unsupported hash algorithm:", algo)
		os.Exit(1)
	}

	f, err := os.Open(file)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer f.Close()

	_, err = io.Copy(h, f)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	actualHash := hex.EncodeToString(h.Sum(nil))

	fmt.Println("")
	fmt.Println("Algorithm: ", algo)
	fmt.Println("Expected:  ", expectedHash)
	fmt.Println("Actual:    ", actualHash)
	if actualHash != expectedHash {
		fmt.Println("🔴 Checksum did not match")
	} else {
		fmt.Println("🟢 Checksum matched")
	}
}
