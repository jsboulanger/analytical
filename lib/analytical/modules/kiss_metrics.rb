module Analytical
  module Modules
    class KissMetrics
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: KissMetrics -->
          <script type="text/javascript">
            var _kmq = _kmq || [];
            var _kmk = _kmk || '#{options[:key]}';
            function _kms(u){
              setTimeout(function(){
                var d = document, f = d.getElementsByTagName('script')[0],
                s = d.createElement('script');
                s.type = 'text/javascript'; s.async = true; s.src = u;
                f.parentNode.insertBefore(s, f);
              }, 1);
            }
            _kms('//i.kissmetrics.com/i.js');
            _kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');
          </script>
          HTML
          js
        end
      end

      def identify(id, *args)
        data = args.first || {}
        "_kmq.push([\"identify\", \"#{data[:email]}\"]);"
      end

      def event(name, *args)
        data = args.first || {}
        "_kmq.push([\"record\", \"#{name}\", #{data.to_json}]);"
      end

      def set(data)
        return '' if data.blank?
        "_kmq.push([\"set\", #{data.to_json}]);"
      end

      def alias_identity(old_identity, new_identity)
        "_kmq.push([\"alias\", \"#{old_identity}\", \"#{new_identity}\"]);"
      end

    end
  end
end
