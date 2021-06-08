class GithubRepo
  attr_reader :collaborators
  
  def initialize
    @repo_prs = GithubService.num_pull_requests
    @collaborators = GithubService.all_collaborators
    require 'pry'; binding.pry
    #initialize repo object with base endpoint with access to different attributes
    #set constant with the base endpoint and initialize with url paths
  end

  def num_merged_prs
    @repo_prs.find_all do |pr|
      pr[:merged_at]
    end.count
  end
end