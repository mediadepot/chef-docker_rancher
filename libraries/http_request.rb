require 'net/http'

def get(path, params={}, data={}, headers={},opts={})
  request(:get, path, params, data, headers, opts)
end

def post(path, params={}, data={}, headers={}, opts={})
  request(:post, path, params, data, headers, opts)
end

def request(verb, path, params={}, data={}, headers={}, opts={})
  # Build the URI and request object from the given information
  uri = build_uri(path, params)
  request = Net::HTTP.const_get(verb.to_s.capitalize).new(uri.request_uri)
  # Add headers
  default_headers.merge(headers).each do |key, value|
    request.add_field(key, value)
  end

  # Add basic authentication
  if opts[:username] && opts[:password]
    request.basic_auth(opts[:username], opts[:password])
  end

  # Setup PATCH/POST/PUT
  if [:patch, :post, :put].include?(verb)
    if data.respond_to?(:read)
      request.content_length = data.size
      request.body_stream = data
    elsif data.is_a?(Hash)
      request.form_data = data
    else
      request.body = data
    end
  end


  connection = Net::HTTP.new(uri.host, uri.port)

  # Create a connection using the block form, which will ensure the socket
  # is properly closed in the event of an error.
  connection.start do |http|
    response = http.request(request)

    case response
      when Net::HTTPRedirection
        redirect = URI.parse(response['location'])
        request(verb, redirect,params, data, headers, opts)
      else
        response.body
    end
  end
# rescue SocketError, Errno::ECONNREFUSED, EOFError
#   raise Error::ConnectionError.new(endpoint)
end

#
# Construct a URL from the given verb and path. If the request is a GET or
# DELETE request, the params are assumed to be query params are are
# converted as such using {Client#to_query_string}.
#
# If the path is relative, it is merged with the {Defaults.endpoint}
# attribute. If the path is absolute, it is converted to a URI object and
# returned.
#
# @param [Symbol] verb
#   the lowercase HTTP verb (e.g. :+get+)
# @param [String] path
#   the absolute or relative HTTP path (url) to get
# @param [Hash] params
#   the list of params to build the URI with (for GET and DELETE requests)
#
# @return [URI]
#
def build_uri(path, params = {})
  # Add any query string parameters
  if params
    path = [path, to_query_string(params)].compact.join('?')
  end

  # Parse the URI
  uri = URI.parse(path)
  return uri
end

#
# The list of default headers (such as Keep-Alive and User-Agent) for the
# client object.
#
# @return [Hash]
#
def default_headers
  {
      'Connection' => 'keep-alive',
      'Keep-Alive' => '30',
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
  }
end

#
# Convert the given hash to a list of query string parameters. Each key and
# value in the hash is URI-escaped for safety.
#
# @param [Hash] hash
#   the hash to create the query string from
#
# @return [String, nil]
#   the query string as a string, or +nil+ if there are no params
#
def to_query_string(hash)
  hash.map do |key, value|
    "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
  end.join('&')[/.+/]
end