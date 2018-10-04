using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StatLogger : MonoBehaviour {

    public Text frameRate;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        float frameRateAtLastFrame = (1.0f / Time.deltaTime);
        frameRate.text = "Frame Rate: " + frameRateAtLastFrame.ToString();
	}
}
