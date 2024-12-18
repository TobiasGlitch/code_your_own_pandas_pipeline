"""
This module contains the function to read the mapping and practice crosstab data from the data
folder.
"""

import pandas as pd
from loguru import logger

from code_your_own_pandas_pipeline.config import RAW_DATA_DIR


def read_mapping_data() -> pd.DataFrame:
    """
    Read the mapping data from the data folder.

    Returns
    -------
    pd.DataFrame
        The mapping data.
    """
    file_path = RAW_DATA_DIR / "Mapping.csv"
    
    logger.info(f"Reading mapping data from {file_path}")

    mapping_df = pd.read_csv(file_path)

    return mapping_df


def read_practice_crosstab_data() -> pd.DataFrame:
    """
    Read the practice crosstab data from the data folder.

    Returns
    -------
    pd.DataFrame
        The practice crosstab data.
    """
    file_paths = [
        "Practice_Level_Crosstab_Aug_24.csv",
        "Practice_Level_Crosstab_Jul_24.csv",
        "Practice_Level_Crosstab_Sep_24.csv"
    ]

    practice_datasets = []
    for file_path in file_paths:
        full_file_path = RAW_DATA_DIR / file_path
        logger.info(f"Reading practice crosstab data from {full_file_path}")

        data = pd.read_csv(full_file_path)
        practice_datasets.append(data)
    
    logger.info("Concatenating the practice crosstab datasets into one dataset")
    practice_crosstab_datasets = pd.concat(practice_datasets)

    return practice_crosstab_datasets
