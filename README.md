## Twitter

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

### Part 2
Time spent: `<11>`

### Features

#### Required

- [x] Hamburger Menu - dragging anywhere in the view should reveal the menu
- [x] Hamburger Menu - should include links to your profile, the home timeline, and the mentions view
- [x] Hamburger Menu - similar idea to LinkedIn menu
- [x] Profile Page - contains the user header view
- [x] Profile Page - Contains a section with the user's basic stats - # tweets, # following, # followers
- [x] Home Timeline - tapping on a user image should bring up that user's profile page

#### Optional

- [x] Pulling down the profile page should blur and resize the header image. (resize only)
- [ ] Implement the paging view for the user description.
- [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
- [ ] Account switching - Long press on tab bar to bring up Account view with animation
- [ ] Account switching - Tap account to switch to
- [ ] Account switching - Include a plus button to Add an Account
- [ ] Account switching - Swipe to delete an account

### Walkthrough

![Video Walkthrough](twitter2.gif)

### Part 1
Time spent: `<17>`

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Walkthrough

![Video Walkthrough](twitter.gif)
