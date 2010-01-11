# v2.0.0 (2010-01-11)

* Added a changelog and a Rake task to help.
* Removed Jeweler's support for Rubyforge.
* Fixed a couple of typos.
* Removed the :browser_only option.
* Tweaked the copyright notice.
* Cleaned up a bit some step definitions.
* Switched to use Rack::Test in the Cucumber's scenarios.
* Removed redundant require in Cucumber's support files.



# v1.1.1 (2009-10-15)

* Tweaked the default HTTP response code.
* Moving to Jeweler.
* Innate example.
* Little tweak to the plain Rack example.
* Plain Rack example.
* Extended the main README.rdoc.
* Fixed loading Rack::Csrf in the Sinatra example. New README.
* Moved the Sinatra example in its own directory.
* Fixed RSpec support file.
* Tweaked Cucumber's task definition.
* Fixed grammar; added some fragments of code.
* Tweaked a bit the Cucumber and RSpec support files.
* Reworded and fixed the spec. It should be clearer.



# 1.1.0 (2009-05-22)

* Tweaks to the examples to run smoothly with future Sinatra release.
* Moved some code into #initialize.
* More generic step checking response code.
* Added the :browser_only option.
* Tweaked Cucumber's profile to follow new Cucumber release.
* Shortened steps' names.
* Tweak to spec to ensure use of csrf_field in csrf_tag.
* Clarification on options' default values.
* :skip now accept an array of regexps.



# 1.0.1 (2009-05-02)

* Changed env key to satisfy Rack specification.
* Auto-fill session with token upon receiving first request.
* Added missing scenarios for :field option.
* Fixed a typo.



# 1.0.0 (2009-04-22 17:14:45 +0200)

* First release
