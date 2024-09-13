function Send-WebexTeamsMessage {

    param(
        [String]$Message,
        [String]$Email,
        [String]$Room
    )

    $endpoint   = "messages"
    $body   = @{
        'markdown'        = $message
    }

    if($email) {
        $body['toPersonEmail']   = $email
    }

    if($room) {
        $body['roomId']   = $room
    }

    Invoke-WebexTeamsPostRequest -Endpoint $endpoint -Body $body 
    
} 