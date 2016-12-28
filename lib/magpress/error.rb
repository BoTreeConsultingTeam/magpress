module Magpress
    # Custom error class for rescuing from all CMS Plugin errors
    class Error < StandardError; end

    # Raised when CMS Plugin returns the HTTP status code 400
    class BadRequestError < Error; end

    # Raised when CMS Plugin returns the HTTP status code 403
    class UnauthorizedError < Error; end

    # Raised when CMS Plugin returns the HTTP status code 404
    class ResourceNotFoundError < Error; end

    # Raised when CMS Plugin returns the HTTP status code 500
    class InternalServerError < Error; end
end