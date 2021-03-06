require 'spec_helper'

describe Tumblargh::Renderer::Blocks::Posts do

  before do
    json_path = File.join(FIXTURE_PATH, "data", "staff.tumblr.com-2012-05-06", "posts.json")
    @json = ActiveSupport::JSON.decode(open(json_path).read)["response"].with_indifferent_access
  end

  it "should render the correct amount of posts" do
    theme = "{block:Posts}!{/block:Posts}"

    result = Tumblargh.render_html(theme, @json)
    result.count("!").should eql @json[:posts].size
  end

  describe "{TagsAsClasses}" do
    let(:post) { Tumblargh::Resource::Post.new({ tags: ["TROLOLOL", "Herp derp"] }, nil) }

    subject { Tumblargh::Renderer::Blocks::Posts.new(nil, post) }

    it "should give the tags as class names" do
      subject.tags_as_classes.should eql "trololol herp_derp"
    end
  end
end
