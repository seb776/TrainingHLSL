using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FumeIndex : MonoBehaviour
{
    void Update()
    {
        this.gameObject.GetComponent<MeshRenderer>().material.SetFloat("_Offset", this.transform.position.x);
    }
}
