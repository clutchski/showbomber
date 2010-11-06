#
# This module contains helper functions used by all views.
#

module ApplicationHelper

  def render_venue(venue)
    return render(:partial => "venues/venue", :locals => {:venue => venue})
  end

  def readable_date(date)
    return date.strftime("%a %b %d")
  end

  def time_of_day(date)
    time_of_day = date.strftime("%I:%M%p")
    #FIXME: better way to do this?
    return time_of_day.start_with?("0") ? time_of_day[1..-1] : time_of_day
  end

  def get_uservoice_url()
    return "http://showbomber.uservoice.com"
  end

  def get_twitter_url()
    "http://twitter.com/showbomber"
  end

  def google_verification_key()
    return "VADO3qdrZJTstl_fCDNJRyiqb7dTwybKYdtUVLHcwr4"
  end

  def google_analytics_javascript()
    analytics = <<SCRIPT
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-19073210-1']);
      _gaq.push(['_trackPageview']);
    
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
SCRIPT
    return analytics
  end
end
