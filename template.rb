unless no?("1/3 Make a commit (yes) ?")
  git add: "."
  git commit: "-m 'Before switching to Webpacker'"
end


remove_dir "app/assets" unless yes?("2/3 Keep the asset directory (no) ?")
default_route_and_action = !no?("3/3 Make a default route and application#index action (yes) ?")


gem 'webpacker'


lines = <<-RUBY
gem 'turbolinks'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
RUBY

lines.each_line do |line|
  gsub_file 'Gemfile', Regexp.new(".*#{line}.*"), ''
end





after_bundle do
  run "spring stop"
  remove_file "config/initializers/assets.rb"

  application do <<-RUBY
  #  config.assets.enabled = false
     config.generators do |g|
       g.assets false
     end
  RUBY
  end

  gsub_file 'config/application.rb', /require 'rails\/all'/, <<-RUBY
  # Pick the frameworks you want:
  require "active_model/railtie"
  require "active_job/railtie"
  require "active_record/railtie"
  require "action_controller/railtie"
  require "action_mailer/railtie"
  require "action_view/railtie"
  require "action_cable/engine"
  #require "sprockets/railtie"
  require "rails/test_unit/railtie"
  RUBY


  gsub_file 'config/environments/development.rb', /(.*assets.*)/, '# \1'
  gsub_file 'config/environments/production.rb', /(.*assets.*)/, '# \1'

  rails_command 'webpacker:install'
  rails_command 'webpacker:install:vue'
  gsub_file 'package.json', /"webpack-dev-server.*/, '"webpack-dev-server": "2.11.1"'
  run 'yarn add rails-ujs turbolinks vue-turbolinks axios vue-axios normalize.css'

  gsub_file 'app/views/layouts/application.html.erb', /.*stylesheet_link_tag.*/,
    "<%= stylesheet_pack_tag 'application', 'data-turbolinks-track': 'reload' %>"
  gsub_file 'app/views/layouts/application.html.erb', /.*javascript_include_tag.*/,
    "<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>"



  inside 'app/javascript/' do
    remove_file 'app.vue'
    remove_file 'packs/application.js'
    remove_file 'packs/hello_vue.js'

    file 'application/Styles.css', <<-CSS
html{
  font-family: sans-serif;
}
body{
  margin: 0 auto;
  max-width: 1000px;
}
CSS

    file 'packs/application.js', <<-JAVASCRIPT
/* eslint no-console: 0 */

import 'normalize.css'
import '../application/Styles.css'

import Turbolinks from 'turbolinks'
import Rails from 'rails-ujs'
Rails.start()
Turbolinks.start()
import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
import App from '../application/App.vue'
import axios from 'axios'
import VueAxios from 'vue-axios'

Vue.use(VueAxios, axios)
Vue.use(TurbolinksAdapter)



document.addEventListener('turbolinks:load', () => {
  let token = document.getElementsByName('csrf-token')[0].getAttribute('content')
  Vue.axios.defaults.headers.common['X-CSRF-Token'] = token
  Vue.axios.defaults.headers.common['Accept'] = 'application/json'
  var element = document.getElementById("vue_app")
  if (element != null) {
    const app = new Vue({
      el: '#vue_app',
      template: '<app />',
      components: { App }
    })
  }
})

JAVASCRIPT

    file 'application/App.vue', <<-HTML
<template>
  <p>{{ message}}</p>
</template>
<script>
  export default {
    data(){
      return {
        message: 'Hello from VueJS !'
      }
    }
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
HTML
  end
  if default_route_and_action
    inject_into_file 'app/controllers/application_controller.rb', :before => "end" do <<-RUBY
    def index
      render :inline => '', layout: 'application'
    end\n
    RUBY
    end
  route "root to: 'application#index'"
  end

  inject_into_file 'app/views/layouts/application.html.erb', :before => "  </body>" do
    "<div id='vue_app'/>\n"
  end
  inject_into_file 'app/views/layouts/application.html.erb', :before => "  </head>" do <<-HTML
    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n
  HTML
  end
end
