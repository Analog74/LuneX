--[[

			  -- NOTIFICATION CARDS v1.0 --

Hello there. This framework was made by Plasma_Node.

Please read the documentation on the devforum post.
Make sure you adjust the DefaultConfig if you want to change default configuration settings.

TO USE:

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
>>>>>>> Place NotificationUI (the screengui) into StartGui. <<<<<<
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The DISABLED localscript called "TEST EXAMPLES" may be deleted, its just to show examples of what the UI can do.

I cannot fit the entire documentation here, plus it is late and i am tired,
but I will give you a quick piece of info on how to send notifications:

(Please remember you can either make your own cards or use the one i provided as default)
--======================================================================================================--

I wanted this system to be relatively simple to use, so I opted for one that can be controlled via Remote Events. Please note that you can use either RemoteEvents or BindableEvents in the exact same way to control the system.

All examples will use the BindableEvent.

-- Sending a premade card:

local Event = game.ReplicatedStorage.NotificationCards.Event;

Event:Fire("Notify", "Mail");

--Now that’s pretty simple. But now, let’s say you want to modify a blank card with code:

Event:Fire("Notify", {
	Name = "Info";
	Title = "DID YOU KNOW?";
	Body = "You can invert flight controls in the settings menu.";
	Sound = "Ping";
	Color = Color3.fromRGB(89, 121, 81)
});


--]]