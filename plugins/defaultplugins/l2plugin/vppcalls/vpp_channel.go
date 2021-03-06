// Copyright (c) 2017 Cisco and/or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package vppcalls

import (
	govppapi "git.fd.io/govpp.git/api"
)

// VPPChannel is interface for send request to VPP channel
type VPPChannel interface {
	SendRequest(msg govppapi.Message) *govppapi.RequestCtx

	SendMultiRequest(msg govppapi.Message) *govppapi.MultiRequestCtx
}

// TODO: maybe add other function of VPP channel.

func boolToUint(value bool) uint8 {
	if value {
		return 1
	}
	return 0
}
