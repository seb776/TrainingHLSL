using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HandleAsteroid : MonoBehaviour
{
    public float Speed;
    public float Radius;
    public Material FrontAsteroidFX;

    void Start()
    {
                
    }
    Vector3 _lastPosition;
    void Update()
    {
        float angle = Time.realtimeSinceStartup*Speed;
        this.gameObject.transform.position = new Vector3(Mathf.Sin(angle)*Radius, 1.0f, Mathf.Cos(angle)*Radius);

        var diff = _lastPosition - this.gameObject.transform.position;
        Debug.Log(diff.magnitude);
        FrontAsteroidFX.SetFloat("_MonFloatTest", diff.magnitude);

        _lastPosition = this.gameObject.transform.position;
    }
}
