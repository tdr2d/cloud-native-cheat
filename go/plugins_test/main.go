package main

import (
	"fmt"
	"plugin"
	"path/filepath"
)

type SortFunc func([]int) *[]int

func main() {
	numbers := []int{5, 2, 7, 6, 1, 3, 4, 8}

	// The plugins (the *.so files) must be in a 'plugins' sub-directory
	all_plugins, err := filepath.Glob("plugins/*.so")
	if err != nil {
		panic(err)
	}

	fmt.Println(all_plugins)
	for _, filename := range (all_plugins) {
		p, err := plugin.Open(filename)
		if err != nil {
			panic(err)
		}
		symbol, err := p.Lookup("Sort")
		if err != nil {
			panic(err)
		}

		sortFunc, ok := symbol.(SortFunc)
		if !ok {
			sortFunc, ok = symbol.(func([]int) *[]int)
		}
		if !ok {
			panic("Plugin doesn't export a Sort([]int) []int function")
		}

		sorted := sortFunc(numbers)
		fmt.Println(filename, sorted)
	}
}