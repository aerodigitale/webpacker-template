# Webpack + VueJS Rails template

__What is it about ?__

Creates a Rails application using Webpack and VueJS instead of the regular Asset Pipeline but with legacy backend routing.

It's intended for embbeding VueJS components in a Rails app with a regular navigation, not for building a single page applications or kind of things.

__Usage__

On a new application :

`rails new -m https://raw.githubusercontent.com/aerodigitale/webpacker-vue-template/master/template.rb`

On an existing application :

`rails app:template LOCATION=https://raw.githubusercontent.com/aerodigitale/webpacker-vue-template/master/template.rb`
(use at your own risk__™__ !)

__What's next ?__

Run `rails s` in a terminal and `bin/webpack-dev-server` in another to launch dev environment with hot javascript reload.

The webpacker gem is compatible with Heroku, so you don't have to worry for the deployment.

__What is done to the created app ?__

- Asset Pipeline and depedencies are disabled
- Assets directory is optionaly removed
- [Webpacker](https://github.com/rails/webpacker) and VueJS are enabled (using the regular webpacker gem commands)
- A VueJS skeleton app is added, with the .vue files component architecture (it's not the default app provided by webpacker).
It comes with Normalize.css and a few styles.
- packs_tags are added to the layout and the regular Asset Pipeline tags are removed
- Turbolinks / Vue-Turbolinks, Rails-UJS and Vue-Axios (with CSRF configuration) are activated the Webpack way

[Read here](https://github.com/jeffreyguenther/vue-turbolinks) on how components are managed with Turbolinks trough Vue-Turbolinks and how to do page-specific component activation (it's done in the skeleton).

__Contribute__

Comments and requests are welcome !

[Clément Alexandre - @clm-a](https://github.com/clm-a)
