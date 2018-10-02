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
	float[] positionsArray;
	MaterialPropertyBlock materialProperty;

	// Use this for initialization
	void Start () {
		materialProperty = new MaterialPropertyBlock();

		instanceCount = positionsList.Count;
		materialProperty.SetFloat(Constants.INSTANCE_COUNTER, instanceCount);

		positionsArray = new float[instanceCount * 3];
	}
	
	// Update is called once per frame
	void Update () {
		for(int i = 0; i < instanceCount; i++)
		{
			int arrayOffset = i * 3;
			Vector3 position = positionsList[i].position;
			positionsArray[0 + arrayOffset] = position.x;
			positionsArray[1 + arrayOffset] = position.y;
			positionsArray[2 + arrayOffset] = position.z;
		}
		
		materialProperty.SetFloatArray(Constants.POSITIONS_ARRAY, positionsArray);
		gameObject.GetComponent<Renderer> ().SetPropertyBlock (materialProperty);
	}
}
