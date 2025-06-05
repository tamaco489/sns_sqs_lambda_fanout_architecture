package sns_client

type MessageType string

const (
	MessageTypeUndefined MessageType = "undefined"
	MessageTypeBroadcast MessageType = "broadcast_message"
	MessageTypeSlack     MessageType = "slack_message"
	MessageTypeLine      MessageType = "line_message"
)

func (m MessageType) String() string {
	return string(m)
}

func (t MessageType) IsValid() bool {
	switch t {
	case MessageTypeBroadcast, MessageTypeSlack, MessageTypeLine:
		return true
	default:
		return false
	}
}
