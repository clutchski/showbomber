module ApplicationHelper

  def get_uservoice_url()
    return "http://showbomber.uservoice.com"
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
