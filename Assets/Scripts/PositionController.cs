using System.Collections;
using System.Collections.Generic;
using UnityEngine;

static class Constants {
	public const string POSITIONS_ARRAY = "_PositionsArray";
	public const string INSTANCE_COUNTER = "_InstanceCounter";
}

public class PositionController : MonoBehaviour {

	public List<Transform> positionsList;
	
	int instanceCount = 0;
	Vector4[] positionsArray;
	MaterialPropertyBlock materialProperty;
    // Use this for initialization
    void Start () {
		materialProperty = new MaterialPropertyBlock();

		instanceCount = positionsList.Count;
		materialProperty.SetFloat(Constants.INSTANCE_COUNTER, instanceCount);

		positionsArray = new Vector4[instanceCount * 3];
        Debug.Log("Instance Count: " + instanceCount);
	}
	
	// Update is called once per frame
	void Update () {
		for(int i = 0; i < instanceCount; i++)
		{
			Vector3 position = positionsList[i].position;
            positionsArray[i] = position;
        }
		
		materialProperty.SetVectorArray(Constants.POSITIONS_ARRAY, positionsArray);
		gameObject.GetComponent<Renderer> ().SetPropertyBlock (materialProperty);
	}
}
