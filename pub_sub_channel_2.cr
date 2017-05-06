class CustomEvent
	property name
	def initialize(name : String)
		@name = name
	end

end

class Subscriber
	property name
	def initialize(name : String)
		@name = name
	end	

	def notify(event : CustomEvent)
		# puts @name + " subscriber notified about the event" + event.name
	end

	def notify(event : Nil)
		# puts @name + " subscriber notified about the nil event"
	end

end


class Publisher
	def initialize
		@subscribers = [] of Subscriber
		@events_stream = Channel(CustomEvent).new
		spawn_workers
	end

	def subscribe(subscriber : Subscriber)
		@subscribers << subscriber
	end

	def catch_event(event : CustomEvent)
		@events_stream.send event
	end

	def spawn_workers
		i = 1
		while(i < 3)
			NotifyWorker.new(i, @subscribers, @events_stream).start
			i = i + 1
		end
	end
end

class NotifyWorker
	def initialize(number : Int32 , subscribers : Array(Subscriber) , stream : Channel(CustomEvent)) 
		puts "spawned worker " + number.to_s
		@num = number
		@subscribers = subscribers
		@stream = stream
	end

	def start
		spawn do 
			loop do 
				notify_subscribers_about_event @stream.receive
			end
		end
	end

	def notify_subscribers_about_event(event : CustomEvent)
		@subscribers.each do |subscriber|
			puts "notifier id: " + @num.to_s + " " +  event.name + " " + subscriber.name
			subscriber.notify(event)
		end
	end

end

publisher = Publisher.new

sub1 = Subscriber.new("Subscriber 1")
sub2 = Subscriber.new("Subscriber 2")
sub3 = Subscriber.new("Subscriber 3")
sub4 = Subscriber.new("Subscriber 4")
sub5 = Subscriber.new("Subscriber 5")
sub6 = Subscriber.new("Subscriber 6")
sub7 = Subscriber.new("Subscriber 7")
publisher.subscribe(sub1)
publisher.subscribe(sub2)
publisher.subscribe(sub3)
publisher.subscribe(sub4)
publisher.subscribe(sub5)
publisher.subscribe(sub6)
publisher.subscribe(sub7)
e1 = CustomEvent.new("event 1")
e2 = CustomEvent.new("event 2")
e3 = CustomEvent.new("event 3")
e4 = CustomEvent.new("event 4")

sleep(5)
publisher.catch_event(e1)
publisher.catch_event(e2)
publisher.catch_event(e3)
publisher.catch_event(e4)
sleep(5)
# publisher.close_stream
# publisher.catch_event(e2)