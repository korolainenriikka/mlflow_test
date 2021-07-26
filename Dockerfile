FROM continuumio/miniconda3:latest

RUN pip install mlflow>=1.17.0 \
    && pip install scikit-learn==0.24.0

