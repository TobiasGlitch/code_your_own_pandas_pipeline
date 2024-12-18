"""
This module contains the functions to process the mapping and practice crosstab data and merge them.
"""

import pandas as pd
from loguru import logger


def tidy_practice_level_data(practice_data: pd.DataFrame) -> pd.DataFrame:
    """
    Tidy the practice crosstab data.

    Parameters
    ----------
    practice_crosstab : pd.DataFrame
        The practice crosstab data.

    Returns
    -------
    pd.DataFrame
        The tidy practice crosstab data.
    """
    logger.info("Tidying the practice crosstab data.")

    # Select the columns we want to use
    practice_data = practice_data[
        [
            "APPOINTMENT_MONTH_START_DATE",
            "GP_CODE",
            "HCP_TYPE",
            "APPT_MODE",
            "NATIONAL_CATEGORY",
            "TIME_BETWEEN_BOOK_AND_APPT",
            "COUNT_OF_APPOINTMENTS",
            "APPT_STATUS",
        ]
    ].copy(deep=True)

    # Convert APPOINTMENT_MONTH_START_DATE to datetime
    practice_data["APPOINTMENT_MONTH_START_DATE"] = pd.to_datetime(
        practice_data["APPOINTMENT_MONTH_START_DATE"], format="%d%b%Y"
    )  # 01JUL2024

    return practice_data


def merge_mapping_and_practice_data(
    mapping_data: pd.DataFrame, practice_data: pd.DataFrame
) -> pd.DataFrame:
    """
    Merge the mapping and practice data.

    Parameters
    ----------
    mapping_data : pd.DataFrame
        The mapping data.
    practice_data : pd.DataFrame
        The practice data.

    Returns
    -------
    pd.DataFrame
        The merged data.
    """
    logger.info("Merging the mapping and practice data.")

    merged_data = pd.merge(
        left=practice_data,
        right=mapping_data,
        on="GP_CODE",
        how="left",
    )

    return merged_data
