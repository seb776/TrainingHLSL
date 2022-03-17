using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BillboardVertical : MonoBehaviour
{
    void Update()
    {
        this.transform.rotation = Quaternion.LookRotation((this.transform.position - Camera.main.transform.position).normalized, Vector3.up);        
    }
}
