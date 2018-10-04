using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstanceCreator : MonoBehaviour {

    public GameObject prefab;
	// Use this for initialization
	void Start () {
        for (int i = 0; i < 37; i++)
        {
            GameObject instance = GameObject.Instantiate(prefab);
            Vector3 position = instance.transform.position;
            position.x *= i;
            instance.transform.position = position;
        }
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
