package main

type Track struct {
	Title    string  `json:"title"`
	Artist   string  `json:"artist"`
	AlbumArt string  `json:"albumArt"`
	Playing  bool    `json:"playing"`
	Status   string  `json:"status"`
	Position float64 `json:"position"`
	Length   float64 `json:"length"`
}

type PerfMetric struct {
	Label string `json:"label"`
	Value string `json:"value"`
	Unit  string `json:"unit,omitempty"`
}
