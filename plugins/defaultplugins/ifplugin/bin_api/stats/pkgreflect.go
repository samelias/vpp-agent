// Code generated by github.com/ungerik/pkgreflect DO NOT EDIT.

package stats

import "reflect"

var Types = map[string]reflect.Type{
	"IP4FibCounter":                      reflect.TypeOf((*IP4FibCounter)(nil)).Elem(),
	"IP4NbrCounter":                      reflect.TypeOf((*IP4NbrCounter)(nil)).Elem(),
	"IP6FibCounter":                      reflect.TypeOf((*IP6FibCounter)(nil)).Elem(),
	"IP6NbrCounter":                      reflect.TypeOf((*IP6NbrCounter)(nil)).Elem(),
	"VnetGetSummaryStats":                reflect.TypeOf((*VnetGetSummaryStats)(nil)).Elem(),
	"VnetGetSummaryStatsReply":           reflect.TypeOf((*VnetGetSummaryStatsReply)(nil)).Elem(),
	"VnetIP4FibCounters":                 reflect.TypeOf((*VnetIP4FibCounters)(nil)).Elem(),
	"VnetIP4NbrCounters":                 reflect.TypeOf((*VnetIP4NbrCounters)(nil)).Elem(),
	"VnetIP6FibCounters":                 reflect.TypeOf((*VnetIP6FibCounters)(nil)).Elem(),
	"VnetIP6NbrCounters":                 reflect.TypeOf((*VnetIP6NbrCounters)(nil)).Elem(),
	"WantIP4FibStats":                    reflect.TypeOf((*WantIP4FibStats)(nil)).Elem(),
	"WantIP4FibStatsReply":               reflect.TypeOf((*WantIP4FibStatsReply)(nil)).Elem(),
	"WantIP4NbrStats":                    reflect.TypeOf((*WantIP4NbrStats)(nil)).Elem(),
	"WantIP4NbrStatsReply":               reflect.TypeOf((*WantIP4NbrStatsReply)(nil)).Elem(),
	"WantIP6FibStats":                    reflect.TypeOf((*WantIP6FibStats)(nil)).Elem(),
	"WantIP6FibStatsReply":               reflect.TypeOf((*WantIP6FibStatsReply)(nil)).Elem(),
	"WantIP6NbrStats":                    reflect.TypeOf((*WantIP6NbrStats)(nil)).Elem(),
	"WantIP6NbrStatsReply":               reflect.TypeOf((*WantIP6NbrStatsReply)(nil)).Elem(),
	"WantInterfaceCombinedStats":         reflect.TypeOf((*WantInterfaceCombinedStats)(nil)).Elem(),
	"WantInterfaceCombinedStatsReply":    reflect.TypeOf((*WantInterfaceCombinedStatsReply)(nil)).Elem(),
	"WantInterfaceSimpleStats":           reflect.TypeOf((*WantInterfaceSimpleStats)(nil)).Elem(),
	"WantInterfaceSimpleStatsReply":      reflect.TypeOf((*WantInterfaceSimpleStatsReply)(nil)).Elem(),
	"WantPerInterfaceCombinedStats":      reflect.TypeOf((*WantPerInterfaceCombinedStats)(nil)).Elem(),
	"WantPerInterfaceCombinedStatsReply": reflect.TypeOf((*WantPerInterfaceCombinedStatsReply)(nil)).Elem(),
	"WantPerInterfaceSimpleStats":        reflect.TypeOf((*WantPerInterfaceSimpleStats)(nil)).Elem(),
	"WantPerInterfaceSimpleStatsReply":   reflect.TypeOf((*WantPerInterfaceSimpleStatsReply)(nil)).Elem(),
	"WantStats":                          reflect.TypeOf((*WantStats)(nil)).Elem(),
	"WantStatsReply":                     reflect.TypeOf((*WantStatsReply)(nil)).Elem(),
}

var Functions = map[string]reflect.Value{
	"NewVnetGetSummaryStats":                reflect.ValueOf(NewVnetGetSummaryStats),
	"NewVnetGetSummaryStatsReply":           reflect.ValueOf(NewVnetGetSummaryStatsReply),
	"NewVnetIP4FibCounters":                 reflect.ValueOf(NewVnetIP4FibCounters),
	"NewVnetIP4NbrCounters":                 reflect.ValueOf(NewVnetIP4NbrCounters),
	"NewVnetIP6FibCounters":                 reflect.ValueOf(NewVnetIP6FibCounters),
	"NewVnetIP6NbrCounters":                 reflect.ValueOf(NewVnetIP6NbrCounters),
	"NewWantIP4FibStats":                    reflect.ValueOf(NewWantIP4FibStats),
	"NewWantIP4FibStatsReply":               reflect.ValueOf(NewWantIP4FibStatsReply),
	"NewWantIP4NbrStats":                    reflect.ValueOf(NewWantIP4NbrStats),
	"NewWantIP4NbrStatsReply":               reflect.ValueOf(NewWantIP4NbrStatsReply),
	"NewWantIP6FibStats":                    reflect.ValueOf(NewWantIP6FibStats),
	"NewWantIP6FibStatsReply":               reflect.ValueOf(NewWantIP6FibStatsReply),
	"NewWantIP6NbrStats":                    reflect.ValueOf(NewWantIP6NbrStats),
	"NewWantIP6NbrStatsReply":               reflect.ValueOf(NewWantIP6NbrStatsReply),
	"NewWantInterfaceCombinedStats":         reflect.ValueOf(NewWantInterfaceCombinedStats),
	"NewWantInterfaceCombinedStatsReply":    reflect.ValueOf(NewWantInterfaceCombinedStatsReply),
	"NewWantInterfaceSimpleStats":           reflect.ValueOf(NewWantInterfaceSimpleStats),
	"NewWantInterfaceSimpleStatsReply":      reflect.ValueOf(NewWantInterfaceSimpleStatsReply),
	"NewWantPerInterfaceCombinedStats":      reflect.ValueOf(NewWantPerInterfaceCombinedStats),
	"NewWantPerInterfaceCombinedStatsReply": reflect.ValueOf(NewWantPerInterfaceCombinedStatsReply),
	"NewWantPerInterfaceSimpleStats":        reflect.ValueOf(NewWantPerInterfaceSimpleStats),
	"NewWantPerInterfaceSimpleStatsReply":   reflect.ValueOf(NewWantPerInterfaceSimpleStatsReply),
	"NewWantStats":                          reflect.ValueOf(NewWantStats),
	"NewWantStatsReply":                     reflect.ValueOf(NewWantStatsReply),
}

var Variables = map[string]reflect.Value{}

var Consts = map[string]reflect.Value{
	"VlAPIVersion": reflect.ValueOf(VlAPIVersion),
}