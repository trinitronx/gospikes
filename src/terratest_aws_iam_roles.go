package main

import (
	//"encoding/json"
	//"bytes"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	//"runtime"
	//"strings"
	//"testing"

	"github.com/joho/godotenv"
	//"github.com/gruntwork-io/terratest/modules/aws"
	//"github.com/gruntwork-io/terratest/modules/random"
	//"github.com/gruntwork-io/terratest/modules/terraform"
	//test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	//"github.com/stretchr/testify/assert"
)

// Let's implement 2 more features of curl;  One is to send the output to a file,
// And the other is to squelch printing to Stdout.  Unlike curl, we'll make these
// independent;  we'll always output to Stdout unless silent is true.
var Config struct {
	Silent   bool
	DestFile string
}

var nukeAccountID string

const dotEnvHelpText = `A value for AWS_NUKE_ACCOUNT_ID is required!

Either:

1) Define the environment variable AWS_NUKE_ACCOUNT_ID

OR

2) Create a .env file in the current directory that defines AWS_NUKE_ACCOUNT_ID

Example:

AWS_NUKE_ACCOUNT_ID=<YOUR TERRATEST AWS ACCOUNT ID HERE>

`

// Global io.MultiWriter logging
var (
	//buf    bytes.Buffer
	// log.New(&buf, ... )
	// teeReader = io.TeeReader(&buf, os.Stdout)
	// this is a slice of io.Writers we will write the file to
	writers []io.Writer

	multiWriter = io.MultiWriter(writers...)
	logger = log.New(os.Stdout, "logger: ", log.Ldate | log.Ltime | log.Lmicroseconds | log.Lshortfile)

	infof = func(format string, info string) {
		logger.Output(2, fmt.Sprintf(format, info))
	}
	info = func(info string) {
		logger.Output(2, info)
	}
)

// initialize command line flag settings
func init() {
	// Let the flag package handle the options;  -o for output and -s for silent
	flag.StringVar(&Config.DestFile, "o", "", "output file")
	flag.BoolVar(&Config.Silent, "s", false, "silent (do not output to stdout)")
	flag.Parse()

	if len(flag.Args()) != 1 {
		path, err := os.Executable()
		if err != nil {
			panic(err)
		}
		filename := filepath.Base(path)
		fmt.Printf("Usage: %v [options] <path-prefix>\n", filename)
		os.Exit(-1)
	}
}

func main() {
	// if we aren't in Silent mode, lets add Stdout to our writers
	if !Config.Silent {
		writers = append(writers, os.Stdout)
	}
	// if DestFile was provided, lets try to create it and add to the writers
	if len(Config.DestFile) > 0 {
		file, err := os.Create(Config.DestFile)
		if err != nil {
			fmt.Println(err)
			return
		}
		writers = append(writers, file)
		defer file.Close()
	}

	// Load .env file
	err := godotenv.Load()
	nukeAccountID = os.Getenv("AWS_NUKE_ACCOUNT_ID")
	if err != nil && nukeAccountID == "" {
		info(dotEnvHelpText)
		logger.Fatal("Error loading .env file")
	} else if err == nil {
		info("Loaded .env file")
	} else if nukeAccountID != "" {
		info("Loaded AWS_NUKE_ACCOUNT_ID from environment")
	}

	nukeAccountID = os.Getenv("AWS_NUKE_ACCOUNT_ID")
	infof("AWS_NUKE_ACCOUNT_ID = %s", nukeAccountID)

	//fmt.Print(&buf)
}
