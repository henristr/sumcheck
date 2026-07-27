package main

import (
	"flag"
)

type CmdFlags struct {
	Algo     string
	Expected string
	File     string
}

func NewCmdFlags() *CmdFlags {
	cf := CmdFlags{}

	flag.StringVar(&cf.Algo, "a", "", "Specify the hash algorithm")
	flag.StringVar(&cf.Expected, "e", "", "Specify the expected hash algorithm")
	flag.StringVar(&cf.File, "f", "", "Specify the file name")

	flag.Parse()

	return &cf
}

func (cf *CmdFlags) Execute() {
	switch {
	case cf.Algo != "" || cf.Expected != "" || cf.File != "":
		calcHash(cf.Algo, cf.Expected, cf.File)
	}
}
