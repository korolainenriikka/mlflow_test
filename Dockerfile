FROM continuumio/miniconda3:latest

COPY /media/volume/* ./data

RUN pip install mlflow>=1.17.0 \
    && pip install scikit-learn==0.23.2

