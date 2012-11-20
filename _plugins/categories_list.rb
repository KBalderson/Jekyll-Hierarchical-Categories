module Jekyll

  class CategoriesList < Generator

    attr_accessor :site

    class << self; attr_accessor :site; end

    def generate (site)
      self.class.site = self.site = site
      add_categories_list
    end

    def categories_list(posts)
      nesting = {}

      unless posts.nil?
        posts.each do |post|

          categories = post.categories.reverse
          first = true
          nest = {}

          categories.each do |category|
            if first
              nest[category] = { 
                "posts" => { post.data['title'] => post.to_liquid },
                "title" => category
              }
            else
              nest_tmp = nest
              nest = {
                category => { 
                  "categories" => nest_tmp,
                  "title" => category
                }
              }
            end
            first = false
          end

          nesting = nesting.deep_merge(nest)

        end

      end

      nesting

    end

    def add_categories_list
      s, t = site, { "hierarchy" => categories_list(site.posts) }
      s.respond_to?(:add_payload) ? s.add_payload(t) : s.config.update(t)
    end

  end

end
