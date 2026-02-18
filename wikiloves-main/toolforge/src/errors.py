"""
Custom exception classes for the Toolforge data fetcher.
"""


class WikiLovesError(Exception):
    """Base exception for all Wiki Loves errors."""
    pass


class DatabaseError(WikiLovesError):
    """Database connection or query execution error."""
    pass


class QueryTimeoutError(DatabaseError):
    """Query execution exceeded timeout."""
    pass


class ProcessingError(WikiLovesError):
    """Data processing error."""
    pass


class ValidationError(WikiLovesError):
    """Data validation error."""
    pass


class CampaignNotFoundError(WikiLovesError):
    """Campaign not found error."""
    pass


class QueryGenerationError(WikiLovesError):
    """Error generating SQL query."""
    pass
