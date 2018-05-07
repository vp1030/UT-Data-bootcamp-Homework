import os
import pandas as pd
import numpy as np
import sqlalchemy
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from flask import Flask, render_template, jsonify, request, redirect
from sqlalchemy.ext.automap import automap_base


app = Flask(__name__)

#Database setup
db_uri = os.getenv("DATABASE_URI", "sqlite:///data/belly_button_biodiversity.sqlite")
engine = create_engine(db_uri)

# reflect an existing database into a new model
Base = automap_base()

# reflect the tables
Base.prepare(engine, reflect=True)

# assign each table class to a variable
OTU = Base.classes.otu
Samples = Base.classes.samples
Metadata_Samples = Base.classes.samples_metadata

# create a session
session = Session(engine)

# load the otu table into a dataframe
query_statement = session.query(otu).order_by(otu.otu_id).statement
otu_df = pd.read_sql_query(query_statement, session.bind)

# load the samples table into a dataframe
query_statement = session.query(samples).order_by(samples.otu_id).statement
samples_df = pd.read_sql_query(query_statement, session.bind)

# load the samples_metadata table into a dataframe
query_statement = session.query(samples_metadata).order_by(samples_metadata.SAMPLEID).statement
samples_meta_df = pd.read_sql_query(query_statement, session.bind)

# the root route that renders index.html template which is the dashboard page
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/names')
def names():
    names_info = session.query(Samples).statements
    names_df = pd.read_sql_query(names_info, session.bind)
    names_df.set_index("otu_id", inplace = True)
    return jsonify(list(names_df.columns))

@app.route('/otu')
def otu_column():
    otu_info = session.query(OTU).statement
    otu_df = pd.read_sql_query(otu_info, session.bind)
    otu_df.set_index("otu_id", inplace=True)
    otu_column = list(otu_df.lowest_taxonomic_unit_found)
    return jsonify(otu_column)

@app.route('/metadata/<sample>')
def metadata(sample):

    id_samples = int(sample[3:])
    mtdata_samples = {}
    results = session.query(Metadata_Samples)

    for result in results:
        if (id_samples == result.SAMPLEID):
            mtdata_samples["AGE"] = result.AGE
            mtdata_samples["BBTYPE"] = result.BBTYPE
            mtdata_samples["ETHNICITY"] = result.ETHNICITY
            mtdata_samples["GENDER"] = result.GENDER
            mtdata_samples["LOCATION"] = result.LOCATION
            mtdata_samples["SAMPLEID"] = result.SAMPLEID
    return jsonify(mtdata_samples)

@app.route('/wfreq/<sample>')
def wfreq(sample):

    id_samples = int(sample[3:])
    answ = session.query(Metadata_Samples)

    for result in results:
        if sample_id == result.SAMPLEID:
            wfreq = result.WFREQ
    return jsonify(wfreq)

@app.route('/samples/<sample>')
def samples(sample):

        sample_selection = session.query(Samples).statement
        ss_df = pd.read_sql_query(sample_selection, session.bind)
        ss_df = ss_df[ss_df[sample] > 1]
        ss_df = ss_df.sort_values(by=sample, ascending=0)

    ov_sa_data = [{
        "otu_ids": ss_df[sample].index.values.tolist(),
        "sample_values": ss_df[sample].values.tolist()
    }]
    return jsonify(ov_sa_data)

if __name__ == "__main__":
    app.run(debug=True)