FROM continuumio/miniconda3:latest

RUN pip install mlflow>=1.17.0 \
    && pip install scikit-learn==0.23.2

