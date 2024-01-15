// Copyright 2022 CloudWeGo Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

package main

import (
	goflag "flag"
	"fmt"

	gatewaycmd "github.com/wheelergeo/g-otter-gateway/cmd"
	usercmd "github.com/wheelergeo/g-otter-micro-user/cmd"

	"github.com/cloudwego/kitex/pkg/klog"
	"github.com/spf13/cobra"
)

var (
	moduleName = "g-otter"
	rootCmd    = &cobra.Command{
		Use:   moduleName,
		Short: fmt.Sprintf("%s module", moduleName),
	}
)

func main() {
	rootCmd.PersistentFlags().AddGoFlagSet(goflag.CommandLine)
	rootCmd.AddCommand(
		gatewaycmd.Command(),
		usercmd.Command(),
	)

	if err := rootCmd.Execute(); err != nil {
		klog.Fatal(err)
	}
}
