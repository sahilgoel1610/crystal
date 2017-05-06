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
		puts @name + " subscriber notified about the event" + event.name
	end

	def notify(event : Nil)
		puts @name + " subscriber notified about the nil event"
	end

end


class Publisher
	def initialize
		@subscribers = [] of Subscriber
		# puts @subscribers.class
	end

	def subscribe(subscriber : Subscriber)
		@subscribers << subscriber
	end

	def subscribe
		sub1 = Subscriber.new("Subscriber 1")
		sub2 = Subscriber.new("Subscriber 2")
		@subscribers =  [sub1, sub2]
	end

	def notify_all
		@subscribers.each do |subscriber|
			subscriber.notify(@event)
		end
	end

	def catch_event(event : CustomEvent)
		@event = event
		notify_all
	end
end


publisher = Publisher.new

sub1 = Subscriber.new("Subscriber 1")
sub2 = Subscriber.new("Subscriber 2")
publisher.subscribe(sub1)
publisher.subscribe(sub2)
e1 = CustomEvent.new("event 1")
e2 = CustomEvent.new("event 2")


publisher.catch_event(e1)
publisher.catch_event(e2)

