# frozen_string_literal: true
#
require "em-websocket"
require "json"
require "osc-ruby"

EM.run do
  Synth = nil

  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
    puts "*** connect phone app to :8080."

    ws.onopen { |handshake|
      puts "*** Connection from phone on #{handshake.path}"
    }

    ws.onclose { puts "Connection closed from phone." }

    ws.onmessage { |msg|
      parsed_msg = JSON.parse(msg)
      puts "ws onmessage ~> #{parsed_msg}"
      # X position ~> freq
      # Y position ~> amp

      if Synth
        puts "to Synth: OSC '/toggle, #{parsed_msg['x'] + 0.5}"

        Synth.send(OSC::Message.new("/freq", (parsed_msg["x"] + 1)))
        Synth.send(OSC::Message.new("/amp", (parsed_msg["y"] + 1)))

        # case m["x"].to_i
        # when 3..10
        #   puts "#{m["x"]} => Synth 1"
        #   Synth.send "1"
        # when 11..29
        #   puts "#{m["x"]} => Synth 2"
        #   Synth.send "2"
        # when 30..100
        #   puts "#{m["x"]} => Synth 3"
        #   Synth.send "3"
        # end
      end
    }
  end

  Synth = OSC::Client.new("127.0.0.1", 57120)

  puts "*** websockets servers started."
  puts "*** OSC client started."
end
