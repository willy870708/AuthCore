"""
permission request model
"""

from typing import Optional
from datetime import datetime, timedelta
from pydantic import BaseModel, field_validator, model_validator


class PermissionReqModel(BaseModel):
    """
    permission request model
    """

    user_number: str
    granted_start_date: Optional[datetime] = None
    granted_end_date: Optional[datetime] = None
    system_id: int
    page_no: int = 1
    page_size: int = 10

    @field_validator("granted_start_date", "granted_end_date", mode="before")
    @classmethod
    def parse_date_string(cls, value):
        """
        validating parse date string

        Args:
            param1 value: value

        Returns:
            string: value

        Raises:

        """
        if value is None or str(value).lower() in ["", "none", "null"]:
            return None

        return value

    @model_validator(mode="after")
    def check_date_range(self):
        """
        checking date range

        Args:
            param1 value: value

        Returns:
            None

        Raises:
            ValueError
        """
        if self.granted_start_date is None and self.granted_end_date is None:
            self.granted_end_date = datetime.now()
            self.granted_start_date = self.granted_end_date - timedelta(days=180)

        elif self.granted_start_date is None and self.granted_end_date is not None:
            self.granted_start_date = self.granted_end_date - timedelta(days=180)

        elif self.granted_end_date is None and self.granted_start_date is not None:
            self.granted_end_date = self.granted_start_date + timedelta(days=180)

        if self.granted_start_date > self.granted_end_date:
            raise ValueError("Granted start date is after granted end date.")

        date_difference = self.granted_end_date - self.granted_start_date

        if date_difference > timedelta(days=180):
            raise ValueError(
                "The duration between the start and end dates is no more than 180 days."
            )

        self.granted_start_date = self.granted_start_date.strftime("%Y-%m-%d")
        self.granted_end_date = self.granted_end_date.strftime("%Y-%m-%d")

        return self
