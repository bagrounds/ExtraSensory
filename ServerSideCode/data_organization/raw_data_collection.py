'''
raw_data_collection.py

This module is to organize the collected data from ExtraSensory app.
The collected measurements are sent in a zip file (sometimes including also labels from active-feedback) and the labels can also be provided through the api.

This module can help collect them together to an organized directory per user.
This is to be used offline, unrelated to the web service.
--------------------------------------------------------------------------
Written by Yonatan Vaizman. October 2014.
'''
import os;
import fnmatch;
import subprocess;
import json;
import zipfile;
import numpy as np;
import mlpy;
import shutil;


g__data_zip_dir = '/Library/WebServer/Documents/rmw/feedback';
g__feedback_superdir = '/Library/WebServer/Documents/rmw/classifier/feats';
g__output_superdir = '/Users/yonatan/Documents/collected_data';

g__lf_fields = [\
    'altitude','floor','horizontal_accuracy','vertical_accuracy',\
    'wifi_status','app_state','device_orientation','proximity',\
    'on_the_phone'];

def collect_all_instances_of_uuid(uuid,skip_existing):
    for filename in os.listdir(g__data_zip_dir):
        if fnmatch.fnmatch(filename,'*-%s.zip' % uuid):
            print filename;
            parts = filename.split('-');
            timestamp = parts[0];
            collect_single_instance(uuid,timestamp,skip_existing);

            pass; # end if fnmatch...
        pass; # end for filename...

    return;

def collect_single_instance(uuid,timestamp,skip_existing):
    # First check if there is any source of data for this uuid and timestamp:
    input_zip_filename = '%s-%s.zip' % (timestamp,uuid);
    input_zip_file = os.path.join(g__data_zip_dir,input_zip_filename);
    if not os.path.exists(input_zip_file):
        print "-- no zip file %s" % input_zip_file;
        return False;

    # Prepare the output dir:
    uuid_out_dir = os.path.join(g__output_superdir,uuid);
    if not os.path.exists(uuid_out_dir):
        os.mkdir(uuid_out_dir);
        pass;

    instance_out_dir = os.path.join(uuid_out_dir,timestamp);
    if os.path.exists(instance_out_dir):
        if skip_existing:
            print "vvv skipping";
            return True;
        pass;
    else:
        os.mkdir(instance_out_dir);
        pass;

    # Extract the contents of the zip file:
    zf = zipfile.ZipFile(input_zip_file);
    zf.extractall(instance_out_dir);

    # Verify there is the high frequency data file:
    hf_file = os.path.join(instance_out_dir,"HF_DUR_DATA.txt");
    if not os.path.exists(hf_file):
        print "-- no HF data file";
        # Delete the newly created dir:
        os.rmdir(instance_out_dir);
        print "--- Removed dir: %s" % instance_out_dir;
        return False;

    # If there is a label-feedback file, copy it:
    feedback_file = os.path.join(os.path.join(os.path.join(g__feedback_superdir,uuid),timestamp),'feedback');
    if os.path.exists(feedback_file):
        shutil.copy(feedback_file,instance_out_dir);
        print "++ Copied feedback file";
        pass;
    else:
        print "-- No feedback file";
        pass;

    # Read the measurements file and save the different modalities to files:
    (acc,magnet,gyro,gps,lf_data) = read_datafile(hf_file);

    # Save measurement data to modality-separate files:
    np.savetxt(os.path.join(instance_out_dir,'acc'),acc);
    np.savetxt(os.path.join(instance_out_dir,'magnet'),magnet);
    np.savetxt(os.path.join(instance_out_dir,'gyro'),gyro);
    np.savetxt(os.path.join(instance_out_dir,'gps'),gps);

    lf_out_file = os.path.join(instance_out_dir,'lf_measurements.dat');
    fid = open(lf_out_file,'wb');
    json.dump(lf_data,fid);
    fid.close();
    if len(lf_data) > 0:
        print "++ Created low-frequency measures file";
        pass;

    return True;

def read_datafile(hf_file):
    # open the file for reading
    fid = open(hf_file, "r");
    jlist = json.load(fid);
    fid.close();

    # load data into arrays:
    acc = np.zeros((len(jlist),3));
    magnet = np.zeros((len(jlist),3));
    gyro = np.zeros((len(jlist),3));
    gps = np.zeros((len(jlist),3));
    
    lf_data = {};

    #loop through json and write data:
    for j in range(len(jlist)):
        # Read the fields expected in every sample:
        acc[j,0] = jlist[j]['acc_x'];
        acc[j,1] = jlist[j]['acc_y'];
        acc[j,2] = jlist[j]['acc_z'];
        magnet[j,0] = jlist[j]['magnet_x'];
        magnet[j,1] = jlist[j]['magnet_y'];
        magnet[j,2] = jlist[j]['magnet_z'];
        gyro[j,0] = jlist[j]['gyro_x'];
        gyro[j,1] = jlist[j]['gyro_y'];
        gyro[j,2] = jlist[j]['gyro_z'];
        gps[j,0] = jlist[j]['lat'];
        gps[j,1] = jlist[j]['long'];
        gps[j,2] = jlist[j]['speed'];

        # Read the fields expected only in part of the samples:
        for field_name in g__lf_fields:
            lf_field = 'lf_%s' % field_name;
            
            if lf_field in jlist[j]:
                # Make sure this field is in the output dictionary:
                if lf_field not in lf_data:
                    lf_data[lf_field] = [];
                    pass;

                # Add the new found value:
                lf_val = jlist[j][lf_field];
                lf_data[lf_field].append(lf_val);
                pass; # end if lf_filed...
            pass; # end for field_name...
        pass;
        
    return (acc,magnet,gyro,gps,lf_data);


def main():

#    uuid = 'F1F08EA2-44A0-444D-9E2E-821A22D99804';

    uuids = [];
    fid = file('real_uuids.list','rb');
    for line in fid:
        uuids.append(line.strip());
        pass;
    fid.close();

    skip_existing = False;
    for uuid in uuids:
        print "="*20;
        print "=== uuid: %s" % uuid;
        collect_all_instances_of_uuid(uuid,skip_existing);
        pass;

    return;

if __name__ == "__main__":
    main();

