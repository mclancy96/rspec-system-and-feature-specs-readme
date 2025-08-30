# RSpec: System/Feature Specs: Simulating User Behavior with Capybara

Welcome to Lesson 22! In this lesson, we're going to take a deep dive into writing RSpec system and feature specs using Capybara to simulate real user behavior in your Rails app. Capybara is the de facto tool for browser automation in Rails testing, and it lets you write tests that interact with your app just like a real user would—visiting pages, filling out forms, clicking buttons, and even running JavaScript. We'll cover the basics, advanced scenarios, debugging tips, and best practices. If you know Ruby and Rails but are new to automated testing, this is your comprehensive guide to end-to-end user simulation!

---

## What Are System/Feature Specs?

System (or feature) specs are high-level, end-to-end tests that interact with your app like a real user would—by visiting pages, filling out forms, clicking links, and more. They:

- Test the full stack: routing, controllers, models, views, and even JavaScript (if enabled)
- Are perfect for testing user flows, UI behavior, and integration between components
- Help ensure your app works as expected from the user's perspective
- Catch bugs that unit tests and model/controller specs might miss

**Why not just test models and controllers?** Because users don't interact with your app by calling methods—they use the browser! System specs make sure the whole experience works.

---

## Setting Up Capybara

Capybara is the go-to tool for simulating browser interactions in Rails. It works with RSpec out of the box if you use `rspec-rails`, but you can always add it explicitly:

```ruby
# /Gemfile
gem 'capybara'
```

Then run:

```zsh
# Terminal
bundle install
```

In your RSpec config (usually in `/spec/rails_helper.rb`):

```ruby
# /spec/rails_helper.rb
require 'capybara/rspec'
```

**Capybara Drivers:**
Capybara supports several drivers for simulating browsers:

- `:rack_test` (default): Fast, headless, but **no JavaScript** support. Great for simple, non-JS specs.
- `:selenium_chrome_headless`: Real browser, supports JavaScript, runs headless (no visible window). Good for most JS specs.
- `:selenium_chrome`: Real browser, supports JavaScript, opens a visible Chrome window (useful for debugging).
- `:cuprite` or `:webkit`: Alternative JS drivers, sometimes faster or more stable for certain apps.

Set your JS driver in `/spec/rails_helper.rb`:

```ruby
Capybara.javascript_driver = :selenium_chrome_headless
```

**Driver pros/cons:**

- `rack_test`: Fastest, but can't test JS or some advanced browser features.
- `selenium_chrome_headless`: Slower, but closest to real user experience (supports JS, CSS, etc.).

---

## Database Transactions vs Truncation (JS Specs)

By default, Rails and RSpec use transactional fixtures to roll back DB changes between tests. **But:**

- For JavaScript-enabled specs (`js: true`), transactions don't work across threads/processes. You need to use truncation (clearing the DB between tests) instead.
- Tools like DatabaseCleaner can help. If you see weird data issues in JS specs, check your DB cleaning strategy!

**Tip:** In Rails 5.1+, system specs handle this for you, but it's good to know why JS specs are different

---

## Asynchronous Behavior & Waiting

Capybara automatically waits for elements to appear (up to a timeout), so you rarely need to add `sleep`. But for very dynamic JS, you can:

- Use `expect(page).to have_content("Text", wait: 5)` to increase the wait time.
- Use `find(".selector", wait: 10)` for slow-loading elements.

**Edge Case:** If your test fails because an element isn't found, try increasing the wait or checking for the right selector

---

## Advanced Selectors: CSS & XPath

Capybara lets you use CSS or XPath selectors for precise queries:

```ruby
find("#main-nav .nav-link.active") # CSS selector
find(:xpath, "//div[@id='main-nav']//a[contains(@class, 'active')]") # XPath selector
```

You can use these in `find`, `within`, or any Capybara query method

---

## Performance Note: When to Use System Specs

System specs are powerful but **slower** than unit or request specs, because they boot the full Rails app and (for JS) a real browser. Use them for critical user flows and UI features, not every tiny detail.

**Tip:** Cover core user journeys with system specs, and use faster specs (model, request) for logic and API details.

---

## Example: Visiting a Page

Let's start simple: visit a page and check for content.

```ruby
# /spec/system/homepage_spec.rb
require 'rails_helper'

RSpec.describe "Homepage", type: :system do
  it "shows the welcome message" do
    visit "/"
    expect(page).to have_content("Welcome")
  end
end
```

**What happens?**
Capybara opens the homepage, and checks that the text "Welcome" appears somewhere on the page.

**Output Example:**

```zsh
Homepage
  shows the welcome message

Finished in 0.0123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

---

## Example: Filling Out a Form

Suppose you have a sign-up form:

```erb
<!-- /app/views/users/new.html.erb -->
<%= form_with model: @user do |f| %>
  <%= f.text_field :username %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.submit "Sign Up" %>
<% end %>
```

Test the form:

```ruby
# /spec/system/user_signup_spec.rb
require 'rails_helper'

RSpec.describe "User Signup", type: :system do
  it "allows a user to sign up" do
    visit "/users/new"
    fill_in "Username", with: "bob"
    fill_in "Email", with: "bob@example.com"
    fill_in "Password", with: "password123"
    click_button "Sign Up"
    expect(page).to have_content("Account created")
  end
end
```

**What happens?**
Capybara fills in the form fields, clicks the button, and checks for a success message.

**Edge Case:**
What if the form is missing a field? Capybara will raise an error if it can't find the field by label or name.

---

## Example: Navigation

Navigation is a key part of user experience. Let's test clicking a link:

```ruby
# /spec/system/navigation_spec.rb
require 'rails_helper'

RSpec.describe "Navigation", type: :system do
  it "lets the user navigate from home to about page" do
    visit "/"
    click_link "About"
    expect(page).to have_content("About Us")
  end
end
```

**What happens?**
Capybara clicks the "About" link and checks that the "About Us" content appears.

**Tip:** You can use `click_link` with the link text, id, or even a partial match.

---

## Example: JavaScript-Enabled Features

Capybara can test JavaScript features if you use a JS driver (like Selenium). Just add `js: true` to your spec:

```ruby
# /spec/system/modal_spec.rb
require 'rails_helper'

RSpec.describe "Modal", type: :system, js: true do
  it "shows a modal when button is clicked" do
    visit "/"
    click_button "Show Modal"
    expect(page).to have_selector(".modal", visible: true)
  end
end
```

**What happens?**
Capybara launches a real browser (headless by default), clicks the button, and checks for the modal.

**Debugging Tip:**
Add `save_and_open_screenshot` or `save_and_open_page` to see what Capybara sees:

```ruby
# /spec/system/modal_spec.rb
save_and_open_screenshot
```

---

## Example: Interacting with Tables and Lists

```ruby
# /spec/system/table_spec.rb
require 'rails_helper'

RSpec.describe "Table", type: :system do
  it "shows a list of users" do
    create_list(:user, 3)
    visit "/users"
    within "table.users" do
      expect(page).to have_selector("tr", count: 4) # 3 users + header row
    end
  end
end
```

---

## Example: File Uploads

```ruby
# /spec/system/file_upload_spec.rb
require 'rails_helper'

RSpec.describe "File Upload", type: :system do
  it "lets the user upload a file" do
    visit "/uploads/new"
    attach_file "Document", Rails.root.join("spec/fixtures/sample.pdf")
    click_button "Upload"
    expect(page).to have_content("Upload successful")
  end
end
```

---

## Capybara's DSL: Common and Advanced Methods

- `visit "/path"` — Go to a page
- `fill_in "Field", with: "value"` — Fill out a form field
- `choose "Radio"` — Select a radio button
- `check "Checkbox"` / `uncheck "Checkbox"` — Toggle a checkbox
- `select "Option", from: "Dropdown"` — Select from a dropdown
- `click_button "Button"` — Click a button
- `click_link "Link"` — Click a link
- `attach_file "Label", "/path/to/file"` — Upload a file
- `within(".selector") { ... }` — Scope actions to a part of the page
- `expect(page).to have_content("Text")` — Check for text
- `expect(page).to have_selector(".css-class")` — Check for an element
- `save_and_open_page` / `save_and_open_screenshot` — Debugging helpers

**Pro Tip:** Capybara waits for elements to appear (up to a timeout), so you rarely need to add `sleep`.

---

## Capybara Best Practices & Gotchas

- Use factories to set up data for your specs (FactoryBot is your friend!)
- Use `within` to scope actions to a specific part of the page
- Prefer using visible text for selectors (matches what users see)
- For JavaScript, always add `js: true` and use a JS driver
- Use `save_and_open_page` to debug failing specs
- Don't test implementation details—test what the user sees and does

**Common Pitfall:** Capybara can't "see" elements hidden by CSS or JavaScript. Use `visible: false` if you need to check for hidden elements, but prefer to test visible UI.

---

## Practice Prompts & Reflection Questions

Try these exercises to reinforce your learning:

1. Write a system spec that visits a page and checks for specific content. What happens if the content is missing?
2. Write a system spec that fills out a form and submits it. How do you check for both success and error messages?
3. Write a system spec that clicks a link and verifies navigation. How would you test a redirect?
4. Write a system spec for a JavaScript-enabled feature. What changes when you add `js: true`? How do you debug failures?
5. Write a system spec that uploads a file and checks for a success message.
6. Use `within` to scope your assertions to a table or sidebar.
7. Why is it important to test user flows, not just models and controllers?

Reflect: What could go wrong in your app if you never test the UI from the user's perspective? How might a user experience a bug that your model/controller specs would miss?

---

## Resources

- [RSpec: System Specs](https://relishapp.com/rspec/rspec-rails/v/5-0/docs/system-specs/system-spec)
- [Capybara Documentation](https://teamcapybara.github.io/capybara/)
- [Rails Guides: Testing Rails Applications](https://guides.rubyonrails.org/testing.html#system-testing)
- [Better Specs: Feature Specs](https://www.betterspecs.org/#feature)
- [Capybara Cheat Sheet](https://gist.github.com/zhengjia/428105)
- [Capybara Drivers](https://github.com/teamcapybara/capybara#drivers)
