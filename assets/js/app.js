import "phoenix_html"
import LiveSocket from "phoenix_live_view"

import "./../css/app.scss"

let liveSocket = new LiveSocket("/live")
liveSocket.connect();