# Demo Webhook App

An extremely simple app to demostrate the Proof of Concept for the Webhook system. 

## Setup
Clone this to your local repository, run `bundle install` and typical setup commands. You will want to run the server on port 3001 - use the command `rails server -p 3001`. You will also need workers running on your base app; you can run workers with `bundle exec rake:work`

Once it's running you can access the main view at `http://localhost:3001/events`. It will look like a blank page.

## Usage
To hook into this just create a WebhookSubscription with the following attributes:

```ruby
WebhookSubscription.create({
   name: 'Test Webhook',
   scopes: ['*'],
   partner_id: 1,
   callback_url: 'http://localhost:3001/api/events'   
})
```

Once that's created you will now have to trigger an event that will set off the Webhook. To do this run the following commands in Rails console:

```ruby
# We have to get a User for the correct Partner
user = User.select { |user| user.partner_id == 1 }.sample

# We need Params to build the event, but set the id to nil
params = Task.last.attributes
params['id'] = nil

# Now run the event with the created args
Api::V1::Tasks::CreateEvent.new.call(data: { user: user, params: params })
```

After running those commands you should see the jobs appear with the workers. Once they've successfully executed go back to `http://localhost:3001/events` and there should be a new JSON object beautifully pasted on the view.

## Testing Use Cases
There are a few different situations you may want to test to confirm this and the Webhook system work as expected:

1. __Webhook gets Subscribed data with a wildcard__: This is what we tested above, just follow those steps.
2. __Webhook only gets Subscribed data__: If you replace the wildcard scope with the class name of a different event (i.e. `Api::V1::Tasks::UpdateEvent`) and run the event from above it should not show up. Alternatively, if you run a `Api::V1::Tasks::UpdateEvent` it should.
3. __Webhook does not get data from other partner__: Swap out the User above for one in a different Partner. The event data should not be sent to the demo app.
4. __Wrong Callback URL is given__: Replace the correct `callback_url` above with a random URL (must still be a URL or validation will fail) and see that it does not cause a breaking error on the main app's side.
