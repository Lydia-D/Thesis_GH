package com.example.lydia.imustream;

import android.content.Context;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;
import android.view.View;

import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
//import android.text.format.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.io.FileWriter;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class MainActivity extends AppCompatActivity{
// widgets
    public TextView outputText;
    public TextView startText;
    public TextView calText;

// Listeners
    public SensorManager mSensorManager;
    public Sensor mAccelerometer;
    public Sensor mOrientation;

// Data storage
    public ArrayList<IMUdata> DataAcc;
    public ArrayList<IMUdata> DataCal;

// File handling
    public String NAME_FILE;
    public FileWriter FILE;

// Flags
    boolean FLAG_send;
    boolean FLAG_cal;
    //public Time timeobject;

// Activity Handling
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
// Widgets
        outputText = (TextView) findViewById(R.id.outputText);
        startText = (TextView) findViewById(R.id.startText);
        calText = (TextView) findViewById(R.id.calText);

// Listeners
        mSensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        //mOrientation = mSensorManager.getDefaultSensor(Sensor.Type_O)

// Data Handling
        DataAcc = new ArrayList<IMUdata>();
        DataCal = new ArrayList<IMUdata>();

// File Handling
        String currentDateandTime = new SimpleDateFormat("MMdd_HHmmss").format(new Date());
        NAME_FILE = String.format("AccData"+currentDateandTime+".txt");

// Flags
        FLAG_send = false;
        FLAG_cal = false;



    }
    @Override
    protected void onResume(){
        super.onResume();
        mSensorManager.registerListener(accelerationListener,mAccelerometer, mSensorManager.SENSOR_DELAY_NORMAL);

    }
    @Override
    protected void onPause(){
        super.onPause();
        mSensorManager.unregisterListener(accelerationListener);
        flushbuffer();
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        mSensorManager.unregisterListener(accelerationListener);
        flushbuffer();
    }

// Event listeners
    private SensorEventListener accelerationListener = new SensorEventListener() {

        @Override
        public void onAccuracyChanged(Sensor sensor, int acc) {
        }
        @Override
        public void onSensorChanged(SensorEvent event) {
            IMUdata AccObject = new IMUdata(event);
            refreshDisplay(AccObject.getAccDisp());

            if (FLAG_send && !FLAG_cal){
                storebuffer(AccObject);
            }
            if (FLAG_cal){
                // remove last bit of data
                DataCal.add(AccObject);
                if (DataCal.size() >10){
                    // clear flag
                    FLAG_cal = false;
                    FLAG_send = false;
                    calculateCal();
                }
            }
        }
    };

// Data Handling
    private void refreshDisplay(String output) {
        outputText.setText(output);
    }

    private void calculateCal(){
        List<Float> xvec = IMUdata.extractvector(DataCal,"getx");
        List<Float> yvec = IMUdata.extractvector(DataCal,"gety");
        List<Float> zvec = IMUdata.extractvector(DataCal,"getz");
        float[] mean = new float[3];
        mean[0] = myStats.getMean(xvec);
        mean[1] = myStats.getMean(yvec);
        mean[2] = myStats.getMean(zvec);

        float[] stdDev = new float[3];
        stdDev[0] = myStats.getStdDev(xvec,mean[0]);
        stdDev[1] = myStats.getStdDev(xvec,mean[1]);
        stdDev[2] = myStats.getStdDev(xvec,mean[2]);

        IMUdata.setcalibrate(mean,stdDev);
        writeToFile(IMUdata.getcalibrate().getAccDataStr());
        startText.setText("Ready");
        calText.setText(IMUdata.getcalibrate().getAccDisp());
        // change state to now send data again? display calibrated values?

    }


    private void storebuffer(IMUdata object){
        DataAcc.add(object);
        flushbuffer();
    }

    private void flushbuffer(){
        Iterator<IMUdata> IMUdataIterator = DataAcc.iterator();
        try {
            File ALL_FILE = new File(Environment.getExternalStorageDirectory() + "/" + NAME_FILE);
            FILE = new FileWriter(ALL_FILE,true);
            while (IMUdataIterator.hasNext()) {
                //writeToFile(IMUdataIterator.next().getAccDataStr());
                FILE.write(IMUdataIterator.next().getAccDataStr());
                IMUdataIterator.remove();
            }
            FILE.close();
        }catch(IOException e){
            Log.e("Exception", "File write failed: " + e.toString());
        }
    }

    private void writeToFile(String data) {
        try {
            File ALL_FILE = new File(Environment.getExternalStorageDirectory() + "/" +NAME_FILE);
            //Log.e("TAG", ALL_FILE.getPath()); //<-- check the log to make sure the path is correct.
            FILE = new FileWriter(ALL_FILE,true);
            //OutputStreamWriter outputStreamWriter = new OutputStreamWriter(context.openFileOutput(NAME_FILE, Context.MODE_APPEND));
            FILE.write(data);
            FILE.close();
        }
        catch (IOException e) {
            Log.e("Exception", "File write failed: " + e.toString());
        }
    }

// Button Handling
    public void sendButtonClicked(View view){
        startText.setText("Sending Data");
        FLAG_send = true;
    }

    public void stopButtonClicked(View view){
        startText.setText("Stopped Data");
        FLAG_send = false;
        flushbuffer();
    }

    public void calButtonClicked(View view){
        FLAG_cal = true;
        startText.setText("Calibrating Data");
        FLAG_send = false;
        DataAcc.clear();
        DataCal.clear();
        IMUdata.setcalibrate(new float[3],new float[3]); // clear last calibrate data
    }

}

